# n=5 model=out iset=I1 prefix14_class=4965
mov S0, P1
cmp S0, P3
cmovl P1, P3
cmovg S0, P3
cmp P2, P0
mov P3, P2
cmovge P3, P0
cmovle P2, P0
cmp S0, P3
cmovg P0, P3
cmovle P0, S0
cmovle S0, P3
cmovge P3, S0
cmp P1, P2
