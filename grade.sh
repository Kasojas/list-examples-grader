CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> git-output.txt

found=0
for directory in $(find student-submission -not -path '*/.*' -type d)
do
    if ! [ $directory == "student-submission" ]
    then 
        for file in $(find $directory -type f -name "ListExamples.java")
        do
            found=1
            break
        done
    fi
done

if [ $found -eq 1 ]; then
  echo "Submission is in the wrong directory"
  echo "Score: 0"
  exit
fi

cp student-submission/*.java grading-area
cp TestListExamples.java grading-area
cp -r lib grading-area

cd grading-area

if ! [ -f 'ListExamples.java' ]
then
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

filterfound=$(grep -c "static List<String> filter(List<String> list, StringChecker sc)" ListExamples.java)
if [ $filterfound -eq 0 ]
then
    echo "Method Not Found"
    echo "Score: 0"
    exit
fi

mergefound=$(grep -c "static List<String> merge(List<String> list1, List<String> list2)" ListExamples.java)
if [ $mergefound -eq 0 ]
then
    echo "Method Not Found"
    echo "Score: 0"
    exit
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > output.txt

test=$(cat output.txt | tail -n 2 | head -n 1)
fails=$(echo $test | grep 'Failures:')
testsrun=$(echo $test | grep 'Tests run:')
testedrunoutput=$(echo $testsrun | awk -F'[, ]' '{print $3}' )
failed=$(echo $test | awk -F'[, ]' '{print $6}')

if ! [ -z $failed ]
then
    echo $(( $testedrunoutput - $failed ))
    success=$(( $testedrunoutput - $failed ))
    failedscore=$(( $success / $testedrunoutput ))
    echo "Score: $success"
    echo "$failed Test(s) Failed"
    exit
else
    echo "Score: 100"
    exit
fi