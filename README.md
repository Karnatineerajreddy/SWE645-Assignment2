=============================================================================================================== 
Name: Neeraj Reddy Karnati
G#:01502689,
SWE645 Assignment 1
===============================================================================================================

Project Description:
This project hosts a static cricket-themed website on both Amazon S3 and Amazon EC2.
It includes a homepage, survey form, custom error page, image, and stylesheet.
The goal is to demonstrate deploying the same web application using two different AWS services.

===============================================================================================================

Overview
This assignment hosts the same static web application on two platforms:
1. S3 Bucket. 
2. EC2 Instance.

===============================================================================================================

Project Files:

1. index.html: Contain the main page of the website (Cricket World).
2. survey.html: Contain the survey form.
3. error.html: this is a customizable page, used when user try to access a different URL.
4. cricket.jpg: Image
5. index.css: Contain the styling for the index.html.

===============================================================================================================

Task1: S3 Bucket

1. Create S3 Bucket
-> Login to AWS Management Console.
-> Go to S3 
-> Click on Create bucket.
-> Enter a unique bucket name (e.g., swe645neeraj974).
-> Select a region.
-> Uncheck “Block all public access” so the bucket can serve a public website.(AWS will warn that the bucket will be public. Confirm that this is intended.)
-> Leave other settings as default.
-> Click Create.

2. Upload Website Files
-> Open your bucket.
-> Click Upload 
-> Add files / Add folder.
-> Select all files and folders from your project.
-> Click Upload.
-> You can see all the files in your bucket.

3. Enable Static Website Hosting

-> Go to Properties 
-> Click on Static website hosting 
-> CLick Enable.
-> Select Use this bucket to host a website.
-> Set Index document: index.html.
-> Set Error document: error.html.
-> Save changes.

4. Set Public Access Permissions
-> Go to Permissions 
-> Then go to Bucket Policy 
-> Click Edit.
-> Add the following policy:
JSON:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicReadGetObject",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::swe645neeraj974/*"
    }
  ]
}


5. Access the Website:
-> Open the S3 website endpoint
-> URL: http://swe645neeraj974.s3-website-us-east-1.amazonaws.com

6. Custom Error Page

-> The error.html page is shown when the user types an incorrect URL.

-> Note: This customization works only with HTTP, not HTTPS.

===============================================================================================================

Task 2: EC2 Instance Deployment

1. Launch an EC2 Instance

-> Login to AWS Management Console.
-> Navigate to EC2 
-> Launch Instance.
-> Choose an Amazon Machine Image (AMI): Amazon Linux.
-> Choose an Instance Type:t3.micro (free tier eligible) is sufficient.
-> Configure Instance Details:Leave defaults.
-> Add Storage:Leave default (8 GB is fine).
-> Create a new security group or select existing.
-> Add Inbound Rules: (SSH,TCP,22,IP),(HTTP,TCP,80,0.0.0.0/0)
-> Key Pair:Select an existing key pair or create a new one (e.g., newKey.pem).Download the key pair and keep it safe.
-> Click Launch Instance.

2. Connect to EC2 via SSH
-> Open a terminal or PowerShell.
-> Navigate to the directory where your key pair is stored(Store the code Files in there too).
-> Connect to the instance:
    Code: ssh -i newKey.pem ec2-user@ec2-34-207-113-206.compute-1.amazonaws.com

3. Install Web Server
-> I have used Apache.
-> Amazon Linux Code:
    sudo yum update -y 
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd

4. Upload Website Files to EC2
-> Open a terminal from the folder where all the files are saved.
-> Use scp to copy files from your computer to EC2.
    Code:
         scp -i .\newKey.pem index.html cricket.jpg error.html index.css survey.html ec2-user@ec2-34-207-113-206.compute-1.amazonaws.com:/home/ec2-user/
    Output: 
        index.html                                                                            100% 1952   127.1KB/s   00:00
        cricket.jpg                                                                           100% 5460   380.9KB/s   00:00
        error.html                                                                            100%  830    50.7KB/s   00:00
        index.css                                                                             100%  551    33.6KB/s   00:00
        survey.html                                                                           100% 4856   279.0KB/s   00:00

5. In the same Terminal use SSH command with your .pem and the ec2-user id to use the Amazon Linux command prompt.
    Code: ssh -i .\newKey.pem ec2-user@ec2-34-207-113-206.compute-1.amazonaws.com
   ,     #_
   ~\_  ####_        Amazon Linux 2023
  ~~  \_#####\
  ~~     \###|
  ~~       \#/ ___   https://aws.amazon.com/linux/amazon-linux-2023
   ~~       V~' '->
    ~~~         /
      ~~._.   _/
         _/ _/
       _/m/'

6. Move files to the web server directory
[root@ip-172-31-30-53 ~]# sudo cp /home/ec2-user/index.html /var/www/html/
[root@ip-172-31-30-53 ~]# sudo cp /home/ec2-user/survey.html /var/www/html/
[root@ip-172-31-30-53 ~]# sudo cp /home/ec2-user/error.html /var/www/html/
[root@ip-172-31-30-53 ~]# sudo cp /home/ec2-user/index.css /var/www/html/
[root@ip-172-31-30-53 ~]# sudo cp /home/ec2-user/cricket.jpg /var/www/html/

7. Access the Website

-> Open your browser and navigate to
    URL for index.html : http://34.207.113.206
    URL for survey.html : http://34.207.113.206/survey.html

8. Test custom error page by typing an invalid URL
    URL : http://34.207.113.206/indexdd.html
Note: This customization works only with HTTP, not HTTPS.
    Correct URL for error.html page: http://34.207.113.206/error.html
    
