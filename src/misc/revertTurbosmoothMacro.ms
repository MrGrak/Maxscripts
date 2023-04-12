macroScript IC_SelectSubDivNet
category:"IllusionCatalyst Tools"
buttonText:"SelectSubDivNet"
tooltip:"IC.SelectSubDivNet"
(
    rollout rolSelectSubDivNet "Select Sub Div Net"
    (
        label lb_1 "Analysing Geometry..." align:#center offset:[0,0]
        progressBar pbStatus width:100 height:9 color:[0,197,0] align:#center offset:[0,0]
        label lb_2 "Press ESC to cancel" align:#center offset:[0,0]
    )

    function getEPolyEdgesUsingFace theNode theEditPoly baFaces =
    (
        local baEdges = #{}
        local iFaceDeg = 0

        for iFace in baFaces do
        (
            iFaceDeg = theEditPoly.getFaceDegree iFace node:theNode

            for iSide = 1 to iFaceDeg do
                baEdges[theEditPoly.getFaceEdge iFace iSide node:theNode] = true
        )
        return baEdges
    )

    on execute do
    (
        if (Filters.Is_EPoly()) do
        (
            createDialog rolSelectSubDivNet 120 57 style:#(#style_toolwindow, #style_sysmenu, #style_resizing)

            local theNode = selection[1]
            local theBase = theNode.baseObject

            if (getCommandPanelTaskMode() != #modify) do
                setCommandPanelTaskMode #modify

            local theEditObj = modPanel.getCurrentObject()

            local baOldEdgeSel = #{}
            local baNewEdgeSel = #{}

            local baEdgeVerts = #{}
            local baEdgeFaces = #{}

            local baExtEdges = #{}
            local baNewGridVerts = #{}

            local baRefVert = #{}

            local iNumTestEdges = 0
            local bTest = true

            if (classOf theEditObj == Editable_Poly) then
            (
                iNumTestEdges = ( (polyOp.getNumEdges theBase) - ((polyOp.getOpenEdges theBase).numberSet) ) * .5

                baRefVert = polyOp.getVertSelection theBase

                if (baRefVert.numberSet == 1) do
                (
                    baNewEdgeSel = polyOp.getEdgesUsingVert theBase baRefVert

                    while (baNewEdgeSel.numberSet != baOldEdgeSel.numberSet) do
                    (
                        if (keyboard.escPressed) do
                        (
                            bTest = false
                            exit
                        )

                        rolSelectSubDivNet.pbStatus.value = ((baOldEdgeSel.numberSet * 100 / iNumTestEdges) as Integer)

                        baEdgeVerts = polyOp.getVertsUsingEdge theBase (baNewEdgeSel - baOldEdgeSel)
                        baEdgeFaces = polyOp.getFacesUsingEdge theBase (baNewEdgeSel - baOldEdgeSel)

                        baExtEdges = (polyOp.getEdgesUsingVert theBase baEdgeVerts) - (polyOp.getEdgesUsingFace theBase baEdgeFaces) - baOldEdgeSel
                        baNewGridVerts = (polyOp.getVertsUsingEdge theBase baExtEdges) - baEdgeVerts

                        baOldEdgeSel = baNewEdgeSel
                        baNewEdgeSel += polyOp.getEdgesUsingVert theBase baNewGridVerts
                    )

                    if (bTest == true) do
                    (
                        polyOp.setEdgeSelection theBase baNewEdgeSel
                        subObjectLevel = 2
                    )
                )
            )
            else if ((classOf theEditObj) == Edit_Poly) then
            (
                iNumTestEdges = ( (theEditObj.getNumEdges node:theNode) - ((theEditObj.getOpenEdges node:theNode).numberSet) ) * .5

                baRefVert = theEditObj.getSelection #Vertex node:theNode

                if (baRefVert.numberSet == 1) do
                (
                    theEditObj.getEdgesUsingVert &baNewEdgeSel baRefVert node:theNode

                    local baEdgesFromVerts = #{}
                    local baEdgesFromFaces = #{}
                    local baAddEdges = #{}

                    while (baNewEdgeSel.numberSet != baOldEdgeSel.numberSet) do
                    (
                        if (keyboard.escPressed) do
                        (
                            bTest = false
                            exit
                        )

                        rolSelectSubDivNet.pbStatus.value = ((baOldEdgeSel.numberSet * 100 / (iNumTestEdges as Float)) as Integer)

                        theEditObj.getVertsUsingEdge &baEdgeVerts (baNewEdgeSel - baOldEdgeSel)
                        theEditObj.getFacesUsingEdge &baEdgeFaces (baNewEdgeSel - baOldEdgeSel)

                        theEditObj.getEdgesUsingVert &baEdgesFromVerts baEdgeVerts
                        baEdgesFromFaces = getEPolyEdgesUsingFace theNode theEditObj baEdgeFaces

                        baExtEdges = baEdgesFromVerts - baEdgesFromFaces - baOldEdgeSel

                        theEditObj.getVertsUsingEdge &baNewGridVerts baExtEdges
                        baNewGridVerts -= baEdgeVerts

                        baOldEdgeSel = baNewEdgeSel

                        theEditObj.getEdgesUsingVert &baAddEdges baNewGridVerts
                        baNewEdgeSel += baAddEdges
                    )

                    if (bTest == true) do
                    (
                        baNewEdgeSel.count = theEditObj.getNumEdges node:theNode
                        theEditObj.setSelection #Edge baNewEdgeSel node:theNode
                        theEditObj.setEPolySelLevel #Edge
                    )
                )
            )

            try ( destroyDialog rolSelectSubDivNet ) catch ()
        )

        gc light:true
    )
)