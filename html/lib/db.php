<?php
	/**
	 * Connect to the database
	 *
	 * @return object return a database connection handle
	 */
	function connectDB(): object
	{
		$dbh = new PDO('pgsql:host=database;dbname=proto', 'proto', 'proto');
		$dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_WARNING); //PHP warnings for SQL errors
		return $dbh ;
	}
?>