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

cat output.txt

test=$(cat output.txt | tail -n 2 | head -n 1)
fails=$(echo $test | grep 'Failures:')
tests=$(echo $test | grep 'Tests run:')
testS=$(echo $test | grep 'test)')
tested1=$(echo $tests | awk -F'[, ]' '{print $3}' )
tested2=$(echo $testS | awk -F'[( ]' '{print $2}')
fail=$(echo $test | awk -F'[, ]' '{print $6}')
success=$(( $tests - $fail ))

echo "Score: $success / $fail"

echo $test
echo "this"
echo $tested2
echo "next"
echo $fail