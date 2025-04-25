model_list=(qwq-32b)
language_list=(en zh ar bn de es fr id it ja ko ms pt ru sw te th vi)
language_list=(zh ja te)
level_list=(low middle high top)

for i in ${model_list[*]}; do
    for j in ${language_list[*]}; do
        for k in ${level_list[*]}; do
            python run_eval.py --model $i --language $j --level $k
        done
    done
done
