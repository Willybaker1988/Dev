SELECT
    F.name AS FolderName
,   P.name AS ProjectName
,   PKG.name AS PackageName
FROM
    ssisdb.catalog.folders AS F
    INNER JOIN 
        SSISDB.catalog.projects AS P
        ON P.folder_id = F.folder_id
    INNER JOIN
        SSISDB.catalog.packages AS PKG
        ON PKG.project_id = P.project_id
ORDER BY
    F.name
,   P.name
,   PKG.name;