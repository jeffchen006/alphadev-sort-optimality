# n=5 model=out iset=I1 prefix14_class=8177
mov S0, P3
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp P2, P0
mov S0, P2
cmovge S0, P0
cmovle P2, P0
cmp S0, P1
mov P0, P2
cmovg S1, S0
cmovg S0, P1
cmovg P1, S1
cmp P0, P3
