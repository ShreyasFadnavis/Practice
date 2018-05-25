 SELECT
      Title, Price, Quantity,
      IIF(SystemID = 1,
          (
              SELECT
              (
                  SELECT Description
                  FROM Publications.dbo.SeriesNames
                  WHERE SeriesName_ID = Series
              )
              FROM Publications.dbo.Publications WHERE ItemID = I.ItemID
          ),
          IIF(SystemID = 4, 'IHAPI', IIF(SystemID = 7, 'LPG', IIF(SystemID = 6, 'PDMS', NULL)))
      ) Series
  FROM IGSStore.dbo.OrderItems I
  WHERE DateAdded BETWEEN '5/1/2017' AND '8/1/2017'
  
  UNION ALL

  SELECT
      description Title, rate Price, qty Quantity,
      IIF(system_id = 1,
          (
              SELECT
              (
                  SELECT Description
                  FROM Publications.dbo.SeriesNames
                  WHERE SeriesName_ID = Series
              )
              FROM Publications.dbo.Publications WHERE Pub_Num = I.item
          ),
          IIF(system_id = 4, 'IHAPI', IIF(system_id = 7, 'LPG', IIF(system_id = 6, 'PDMS', NULL)))
      ) Series
  FROM Pubsales.dbo.OrderItems I