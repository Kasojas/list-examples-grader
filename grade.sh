CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

cp student-submission/*.java grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area

if ! [ -f 'ListExamples.java' ]
then
    #notInGradingArea=$(find 'ListExamples.java' | wc)
    #notInGradingArea2=$( echo $notInGradingArea | awk -F'[, ]' '{print $1}')
    #echo $notInGradingArea2
    #if [[ $notInGradingArea2 -gt '0']]
    #then 
    #    echo "ListExamples.java wrong directory"
    #    echo "Score: 0"
    #    exit
    #else
    #    echo "ListExamples.java wrong dir"
    #    echo "Score: 0"
    #    exit
    echo "ListExamples.java does not exist"
        echo "Score: 0"
        exit
fi

javac -cp $CPATH *.java 
if [[ $? -ne 0 ]]
then
    echo "Compilation Error"
    echo "Score: 0"
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt

cat output.txt

test=$(cat output.txt | tail -n 2 | head -n 1)
fails=$(echo $test | grep 'Failures:')
tests=$(echo $test | grep 'Tests run:')
testS=$(echo $test | grep 'test)')
tested1=$(echo $tests | awk -F'[, ]' '{print $3}' )
tested2=$(echo $testS | awk -F'[( ]' '{print $2}')
fail=$(echo $test | awk -F'[, ]' '{print $6}')
#success=$(($tests - $fail))

#echo "Score: $success / $fail"

echo $test
echo "this"
echo $tested2
echo "next"
echo $fail