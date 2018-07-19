Configuration LocalServer {

        Node Local {

            File Test {
                DestinationPath = "D:\TestDsc"
                Ensure = "Present"
                Type = "Directory"
            }

            File Test2 {
                DestinationPath = "D:\TestDsc2"
                Ensure = "Present"
                Type = "Directory"
            }
        }
}