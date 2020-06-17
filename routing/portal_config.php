<?php
/*
 * As a work of the United States government, this project is in the public domain within the United States.
 */

class DB_Config
{
    public $dbHost;
    public $dbName;
    public $dbUser;
    public $dbPass;

    public function __construct($sitePath)
    {
        $db = new PDO(
            "mysql:host=".Routing_Config::$dbHost.";dbname=".Routing_Config::$dbName.";charset=UTF8",
            Routing_Config::$dbUser,
            Routing_Config::$dbPass,
            array()
        );
        $sql = "SELECT a.* FROM portal_configs as a WHERE a.path = '$sitePath';";
        $query = $db->prepare($sql);
        $query->execute(array());
        $res = $query->fetchAll(PDO::FETCH_ASSOC);

        $this->dbHost = Routing_Config::$dbHost;
        $this->dbName = $res[0]['database_name'];
        $this->dbUser = Routing_Config::$dbUser;
        $this->dbPass = Routing_Config::$dbPass;
    }

}

class Config
{
    public $title;
    public $city;
    public $adminLogonName;
    public $adPath;
    public $uploadDir;
    public $orgchartPath;
    public $orgchartImportTags;
    public $leafSecure;
    public $onPrem;
    public $descriptionID;
    public $emailPrefix;
    public $emailCC;
    public $emailBCC;
    public $phonedbHost;
    public $phonedbName;
    public $phonedbUser;
    public $phonedbPass;
    public function __construct($sitePath)
    {
        $db = new PDO(
            "mysql:host=".Routing_Config::$dbHost.";dbname=".Routing_Config::$dbName.";charset=UTF8",
            Routing_Config::$dbUser,
            Routing_Config::$dbPass,
            array()
        );
        $sql = "SELECT a.*, b.database_name as phonedbName FROM portal_configs as a JOIN orgchart_configs as b ON a.orgchart_id = b.id WHERE a.path = '$sitePath';";
        $query = $db->prepare($sql);
        $query->execute(array());
        $res = $query->fetchAll(PDO::FETCH_ASSOC);
        $this->title = $res[0]['title'];
        $this->city = $res[0]['city'];
        $this->adminLogonName = $res[0]['adminLogonName'];    // Administrator's logon name
        $this->adPath = $res[0]['active_directory_path']; // Active directory path
        $this->uploadDir = $res[0]['upload_directory'];
        $this->orgchartPath = "../LEAF_Nexus"; // HTTP Path to orgchart with no trailing slash
        $this->orgchartImportTags = $res[0]['orgchart_path'];
        $this->descriptionID = $res[0]['descriptionID'];
        $this->emailPrefix = $res[0]['emailPrefix'];
        $this->emailCC = $res[0]['emailCC'];    // CCed for every email
        $this->emailBCC = $res[0]['emailBCC'];    // BCCed for every email
        $this->phonedbHost = Routing_Config::$dbHost;
        $this->phonedbName = $res[0]['phonedbName'];
        $this->phonedbUser = Routing_Config::$dbUser;
        $this->phonedbPass = Routing_Config::$dbPass;
    }
}