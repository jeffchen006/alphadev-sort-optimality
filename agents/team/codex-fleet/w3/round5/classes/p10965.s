# n=5 model=out iset=I1 prefix14_class=10965
cmp P0, P2
mov S0, P0
cmovle P0, P2
cmovl P2, S0
cmp P1, P3
cmovge S0, P1
cmovge P1, P3
cmovg P3, S0
mov S1, P0
cmp P3, P0
cmovl P0, P3
cmovg S1, P3
cmp P2, P1
cmovle P3, P1
