#!/usr/bin/env cwl-runner
#

cwlVersion: v1.0
class: CommandLineTool
baseCommand: python

inputs:
  - id: synapseConfig
    type: File
  - id: synapseId
    type: string

arguments:
  - valueFrom: downloadSynapseFile.py
  - valueFrom: $(inputs.synapseId)
    prefix: -s
  - valueFrom: $(inputs.synapseConfig.path)
    prefix: -c

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: downloadSynapseFile.py
        entry: |
          #!/usr/bin/env python
          import synapseclient
          import argparse
          import os
          parser = argparse.ArgumentParser()
          parser.add_argument("-s", "--submissionId", required=True, help="Submission ID")
          parser.add_argument("-c", "--synapseConfig", required=True, help="credentials file")
          args = parser.parse_args()
          syn = synapseclient.Synapse(configPath=args.synapseConfig)
          syn.login()
          sub = syn.get(args.submissionId, downloadLocation=".")
          os.rename(sub.path, "gold_standard.csv")
     
outputs:
  - id: filePath
    type: File
    outputBinding:
      glob: gold_standard.csv
