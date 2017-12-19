--truncate table ReestrLocations

BULK INSERT Ufa_Intercity
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\Ufa_Intercity_Routes.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )