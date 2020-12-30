$graph:

- baseCommand: docker 

  class: CommandLineTool
  id: docker-builder  

  inputs:
    context:
       type: Directory
    dockerfile:
       type: File
  arguments:    
  - build
  - prefix: -t
    valueFrom: snap:0.1
  - prefix: -f
    valueFrom: $(inputs.dockerfile) 
  - valueFrom: $(inputs.context.path)

  outputs:
    nothing:
      outputBinding:
        glob: .
      type: Directory
      
  requirements:
    InlineJavascriptRequirement: {}

- baseCommand: gpt
  hints:
    DockerRequirement:
      dockerPull: snap:0.1
  class: CommandLineTool
  id: clt
  inputs:
    inp1:
      inputBinding:
        position: 1
      type: File
    inp2:
      inputBinding:
        position: 2
        prefix: -PselPol=
        separate: false
      type: string
    inp3:
      inputBinding:
        position: 2
        prefix: -PinFile=
        separate: false
      type: Directory
  outputs:
    results:
      outputBinding:
        glob: .
      type: Directory
  requirements:
    EnvVarRequirement:
      envDef:
        PATH: /srv/conda/envs/env_snap/snap/bin:/usr/share/java/maven/bin:/usr/share/java/maven/bin:/opt/anaconda/bin:/opt/anaconda/condabin:/opt/anaconda/bin:/usr/lib64/qt-3.3/bin:/usr/share/java/maven/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin
        PREFIX: /opt/anaconda/envs/env_snap
    ResourceRequirement: {}
  stderr: std.err
  stdout: std.out

- class: Workflow
  doc: SNAP SAR Calibration
  id: main
  inputs:
    polarization:
      doc: Polarization chanel 
      label: Polarization chanel 
      type: string
    snap_graph:
      doc: SNAP Graph
      label: SNAP Graph
      type: File
    safe:
      doc: Sentinel-1 GRD product SAFE Directory
      label: Sentinel-1 GRD product SAFE Directory
      type: Directory[]
    context:
      type: Directory
    dockerfile:
      type: File
  label: SNAP SAR Calibration
  outputs:
  - id: wf_outputs
    outputSource:
    - node_1/results
    type:
      items: Directory
      type: array
  
  requirements:
  - class: ScatterFeatureRequirement
  - class: SubworkflowFeatureRequirement
  
  steps:
    node_0:
      in:
        context: context
        dockerfile: dockerfile
      out:
      - nothing
      run: '#docker-builder'

    node_1:
      in:
        inp1: snap_graph
        inp2: polarization
        inp3: safe
        inp4: node_0/nothing
      out:
      - results
      run: '#clt'
      scatter: inp3
      scatterMethod: dotproduct
cwlVersion: v1.0
