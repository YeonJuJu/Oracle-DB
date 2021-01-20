import java.util.ArrayList;
import java.util.Date;

public class Ex01 {
    public static void main(String[] args){
        Student student1 = new Student();
        student1.setStuNo(1001);
        student1.setName("Jungkook");
        student1.setUserId("rabbit");
        student1.setGrade("5");
        student1.setIdNum("970902-1000000");
        student1.setBirthDate("1997/09/02");
        student1.setTel("010-1234-5678");
        student1.setHeight(178);
        student1.setWeight(75);
        student1.setDeptNo(201);
        student1.setProfNo(9902);

        System.out.println(student1);

        Student student2 = new Student();
        student2.setStuNo(1002);
        student2.setName("JIMIN");
        student2.setUserId("chick");
        student2.setGrade("3");
        student2.setIdNum("951013-1000000");
        student2.setBirthDate("1995/10/13");
        student2.setTel("010-1234-5678");
        student2.setHeight(173);
        student2.setWeight(62);
        student2.setDeptNo(202);
        student2.setProfNo(9902);

        System.out.println(student2);

        Student student3 = new Student();
        student3.setStuNo(1003);
        student3.setName("Yoongi");
        student3.setUserId("cat");
        student3.setGrade("3");
        student3.setIdNum("931013-1000000");
        student3.setBirthDate("1993/10/13");
        student3.setTel("010-1234-5678");
        student3.setHeight(174);
        student3.setWeight(62);
        student3.setDeptNo(201);
        student3.setProfNo(9904);

        System.out.println(student3);

        System.out.println("======================");

        ArrayList<Student> list = new ArrayList<>();
        list.add(student1);
        list.add(student2);
        list.add(student3);

        for(Student student : list){
            System.out.println(student);
        }




    }
}

class Student{
    private int stuNo;
    private String name, userId, grade, idNum;
    private String birthDate;
    private String tel;
    private int height, weight, deptNo, profNo;

    // shift + alt + s
    public int getStuNo(){
        return stuNo;
    }
    public int getHeight(){
        return height;
    }
    public int getWeight(){
        return weight;
    }
    public int getDeptNo(){
        return deptNo;
    }
    public int getProfNo(){
        return profNo;
    }
    public String getName(){
        return name;
    }
    public String getUserId(){
        return userId;
    }
    public String getGrade(){
        return grade;
    }
    public String getIdNum(){
        return idNum;
    }
    public String getTel(){
        return tel;
    }
    public String getBirthDate(){
        return birthDate;
    }

    public void setStuNo(int stuNo){
        this.stuNo = stuNo;
    }
    public void setHeight(int height){
        this.height = height;
    }
    public void setWeight(int weight){
        this.weight = weight;
    }
    public void setDeptNo(int deptNo){
        this.deptNo = deptNo;
    }
    public void setProfNo(int profNo){
        this.profNo = profNo;
    }
    public void setName(String name){
        this.name = name;
    }
    public void setUserId(String userId){
        this.userId = userId;
    }
    public void setGrade(String grade){
        this.grade = grade;
    }
    public void setIdNum(String idNum){
        this.idNum = idNum;
    }
    public void setTel(String tel){
        this.tel = tel;
    }
    public void setBirthDate(String birthDate){
        this.birthDate = birthDate;
    }

    @Override
    public String toString(){
        return stuNo + " == " + name + " == " + userId + " == "  +grade
                + " == " + idNum + " == " + birthDate + " == " + tel + " == "
                + height + " == " + weight + " == " + deptNo + " == " + profNo;
    }
}