<div align="center">

  <h2>
    <img src="ASSETS/pyramid.png" alt="logo" width="25"/>
    PolyMath: Evaluating Mathematical Reasoning in Multilingual Contexts
  </h2>

</div>



<p align="center">
  <a href="https://arxiv.org/abs/2504.xxx">
    <img src="https://img.shields.io/badge/arXiv-2504.xxx-b31b1b.svg?logo=arxiv" alt="arXiv Badge"/>
  </a>
  <a href="https://huggingface.co/datasets/Qwen/PolyMath">
    <img src="https://img.shields.io/badge/HuggingFace-Dataset-yellow?logo=huggingface" alt="Hugging Face Badge"/>
  </a>
  <a href="https://qwen-polymath.github.io/">
    <img src="https://img.shields.io/badge/Leaderboard-Website-brightgreen?logo=trophy" alt="Leaderboard Badge"/>
  </a>
  <a href="./LICENSE">
    <img src="https://img.shields.io/badge/License-Apache 2.0-blue.svg?logo=open-source-initiative" alt="Apache-2.0 License Badge"/>
  </a>
</p>



This is the official repository for the paper **"PolyMath: Evaluating Mathematical Reasoning in Multilingual Contexts"**.


## 📖 Introduction

**PolyMath** is a multilingual mathematical reasoning benchmark **covering 18 languages** and **4 easy-to-hard difficulty levels**. Our benchmark ensures *difficulty comprehensiveness*, *language diversity*, and *high-quality translation*, making it a highly discriminative multilingual mathematical benchmark in the era of reasoning LLMs.



## ✨ Features

- 📈 **Broad Difficulty Range:** PolyMath defines and partitions mathematical difficulty across four levels using two core dimensions: **Thought Depth** and **Knowledge Breadth**, ranging from K-12 to Olympiad and advanced frontier mathematics, with 125 problems per language at each level.

<div align="center">
  <img src="ASSETS/level.png" alt="logo" width="85%"/>
</div>



- 🌍 **Language Diversity:** Each problem in PolyMath is available in **18 parallel language versions**, encompassing **over 75% of the world’s native speakers** and major language families, ensuring diversity across both high-resource and low-resource languages.

<div align="center">
  <img src="ASSETS/language.png" alt="logo" width="50%"/>
</div>

- 🧑‍🏫 **High-Quality Annotation:** Each problem translation is **calibrated by language experts**, avoiding direct use of LLM-generated outputs and ensuring precise term and logical clarity.

<div align="center">
  <img src="ASSETS/human.png" alt="logo" width="90%"/>
</div>



## 🛠️ Data Usage

The PolyMath dataset is publicly available and can be accessed in the following ways:

### 📂 Option 1: Use from HuggingFace

The full dataset is hosted on [![Hugging Face](https://img.shields.io/badge/Dataset-HuggingFace-yellow?logo=huggingface)](https://huggingface.co/datasets/your-username/PolyMath).


### 📁 Option 2: Use local files from GitHub

You can also access the same data locally from the `/data` directory in this repository:

```
PolyMath/
└── data/
    ├── ar/
    │   ├── easy.jsonl
    │   ├── medium.jsonl
    │   └── ...
    ├── bn/
    ├── ...
    └── zh/
```

* Additionally, all prompts used in the inference process are provided in `instruction.py`.


## 🧪 Evaluation

### Environment Preparation

```
conda create -n polymath python=3.10
conda activate polymath
pip install -r requirements.txt
```

### Output Process

Given that varying inference engines may generate outputs in different formats, we request that you standardize your results into the specified format:

```
mkdir output
cd output
```

1. Take `/{model_name}` as the primary directory tier, and `/{difficulty_level}` as the secondary tier.

2. For each language, generate a `{lang_name}.jsonl` file within `/{difficulty_level}`, ensuring it includes 125 output samples. Each sample should adhere to the following format:

```json
{"idx: 0, ...}
...
{
  "idx": 114,    ### unique sample id
  "question": "假设在平面上的一个紧集 $C$ 满足以下条件：对每一个方向，都存在一条该方向上的直线 $l$，使得 $l \\cap C$ 的维数至少为 $\\frac{1}{2}$。那么，$C$ 的最小可能维数是多少？",    ### question in corresponding language version
  "answer": "$\\frac{5}{4}$",    ### ground truth
  "thinking_pred": "嗯，这个问题看起来有点挑战性，不过让我慢慢想想。题目是说，在平面上有一个紧集C...",    ### Note: Model's thinking content. Note: If it is a non-reasoning model, leave this field blank.
  "answer_pred": "题目要求在平面上的一个紧集 \\( C \\)，满足对于每一个方向，...",    ### Note: Model's answer content.
}
...
{"idx: 124, ...}
```

The complete file structure is as follows:

```shell
PolyMath/output
 ├── qwq-32b
 │   ├── low
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   ├── medium
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   ├── high
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   └── top
 │       ├── ar.jsonl
 │       ├── bn.jsonl
 │       └── ... 
 ├── deepseek-v3
 │   ├── low
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   ├── medium
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   ├── high
 │   │   ├── ar.jsonl
 │   │   ├── bn.jsonl
 │   │   └── ... 
 │   └── top
 │       ├── ar.jsonl
 │       ├── bn.jsonl
 │       └── ... 
 └── ... (other models)
```

### Score Computation

The `/eval/run_eval.py` provides evaluation code for **accuracy** and **language consistency**. Please run `run_eval.sh` to iterate through your processed output files.

```
cd ../eval
bash run_eval.sh
```

`run_eval.sh`

```shell
model_list=(qwq-32b deepseek-v3)
language_list=(en zh ar bn de es fr id it ja ko ms pt ru sw te th vi)
level_list=(low medium high top)

for i in ${model_list[*]}; do
    for j in ${language_list[*]}; do
        for k in ${level_list[*]}; do
            python run_eval.py --model $i --language $j --level $k
        done
    done
done
```

You can customize `model_list`, `language_list`, and `level_list`. When it is detected that the evaluations for all levels of a particular model in a specific language are completed, the computation of the benchmark score will be triggered.

**During evaluation, a score file will be automatically generated at `/eval/output/{model_name}/score.json`, and all scores will be saved.**


## 📄 Citation

If you use **PolyMath** in your research or find our work useful, please cite us:

```bibtex
@misc{polymath2025,
  title     = {PolyMath: Evaluating Mathematical Reasoning in Multilingual Contexts},
  author    = {xxx},
  year      = {2025},
  eprint    = {2504.xxx},
  archivePrefix = {arXiv},
  primaryClass  = {cs.CL}
}
```
