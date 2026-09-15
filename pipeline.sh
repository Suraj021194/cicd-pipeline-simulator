# layer 1 plan
#!/bin/bash

set -u

# color codes (using \033 [...m escape sequences)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No color - resets back to Normal

# Config 
LOG_FILE="$HOME/DevOpsProject/cicd-pipeline/pipeline.log"
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
ENV="development" #default environment
STAGE=""
APP_DIR="$HOME/DevOpsProject/cicd-pipeline/myapp"

usage(){
    # print usgae instructions for --stage, --env, --help
    echo "STAGE : --stage lets them run a specific stage (build, test or deploy) instead of all of them"
    echo "ENV: --env lets them set which  environment they are targetting (and mention the default is development)"
    echo "HELP: --help shows this message"
}

# argument parsing -same while + case + shift pattern as before 

while [ $# -gt 0 ]; do
    case "$1" in 
        --stage)
            STAGE=$2
            shift 2
            ;;
        --env)
            ENV=$2
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

#Layer 2 - run_stage() helper

run_stage(){
    local stage_name=$1
    local stage_func=$2
    local start_time=$(date +%s)


$stage_func
local exit_code=$?
local end_time=$(date +%s)
local duration=$((end_time-start_time))
if [ $exit_code -eq 0 ]; then
    echo  -e "${GREEN} $stage_name successfully passed and it took $duration seconds ${NC}"
    echo "$stage_name successfully passed and it took that seconds $duration" >> $LOG_FILE
else
    echo -e "${RED} $stage_name fails and it took $duration seconds ${NC}"
    echo "$stage_name fails and it took $duration seconds" >> $LOG_FILE
fi
}

stage_build(){
    if [ -d "$APP_DIR" ]; then
        echo "$APP_DIR exist"
    else
        echo "$APP_DIR does not exist"
        return  1
    fi

    if [ -f "$APP_DIR/app.py" ] && [ -f "$APP_DIR/test_app.py" ] && [ -f "$APP_DIR/requirements.txt" ]; then
        echo "All files exists"
        sleep 2
        return 0
    else
        echo "One of the file does not exist or none of the files exist"
        return 1
    fi
    }
# Layer 4 - stage_test()
stage_test(){
    sleep 1
    local test_passed=0
    local test_failed=0    
    if [ -s "$APP_DIR/app.py" ]; then
        echo "Test1 passed:app.py is not empty"
        test_passed=$((test_passed+1))
    else
        echo "Test1 failed:app.py is empty or missing"
        test_failed=$((test_failed+1))
    fi

    if [ -s "$APP_DIR/test_app.py" ]; then
        echo "Test2 passed:test_app.py is ot empty"
        test_passed=$((test_passed+1))
    else
        echo "Test2 failed:test_app.py ie empty or missing"
        test_failed=$((test_failed+1))
    fi

    echo "Test Passed: $test_passed and Test Failed: $test_failed"
    if [ "$test_failed" -gt 0 ]; then
        return 1
    else
        return 0
    fi
}

# Layer #5
stage_deploy(){
    echo "It is deployed to this $ENV"
    sleep 2
    return 0

}
if [ -z "$STAGE" ]; then
    run_stage "BUILD" stage_build
    run_stage "TEST" stage_test
    run_stage "DEPLOY" stage_deploy

elif [ "$STAGE" == 'build' ]; then
    run_stage "Build" stage_build

elif [ "$STAGE" == 'test' ]; then
    run_stage "Test" stage_test

elif [ "$STAGE" == 'deploy' ]; then
    run_stage "Deploy" stage_deploy

else
    echo "Wrong stage name. Please use correct stage name"
    exit 1
fi

echo -e "${GREEN} Pipeline completed at $ENV with $TIMESTAMP${NC}"