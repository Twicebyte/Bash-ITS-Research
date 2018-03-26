--truncate table PRE_RASP_2

BULK INSERT PRE_RASP_2
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\PREV_PRE_RASP.csv'
    WITH
    (
	FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )


--truncate table GOTHROUGH

BULK INSERT GOTHROUGH_2
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\PREV_GOTHROUGH.csv'
    WITH
    (
	FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table SPEED_UPDATE

BULK INSERT SPEED_UPDATE
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\SPEED_UPDATE.csv'
    WITH
    (
	FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table STREETSTEST

BULK INSERT STREETSTEST
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\PRE_STREETS.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table STREETS_TEMPLATE

BULK INSERT STREETS_TEMPLATE
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\STREETS_TEMPLATE.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table PRE_INTER

BULK INSERT PRE_INTER
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\TIMEPROFILEITEM_M.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

	BULK INSERT PRE_INTER
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\TIMEPROFILEITEM_B.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

	BULK INSERT PRE_INTER
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\TIMEPROFILEITEM_E.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table PRE_INTER_DATA

BULK INSERT PRR_INTER_DATA
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\PRE_INT.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table REGNo

BULK INSERT REGNo
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\REGNo.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )
	
--truncate table CITY_CODES

BULK INSERT CITY_CODES
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\CITY_CODES.csv'
    WITH
    (
	FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )

--truncate table MIRROR

BULK INSERT MIRROR
    FROM N'C:\Users\twice\Documents\GitHub\Bash-ITS-Research\INPUT\MIRROR.csv'
    WITH
    (
	FIRSTROW = 1,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n'   --Use to shift the control to next row
    )