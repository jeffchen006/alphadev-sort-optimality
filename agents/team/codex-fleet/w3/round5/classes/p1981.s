# n=5 model=out iset=I1 prefix14_class=1981
cmp P1, P3
mov S0, P1
cmovle P1, P3
mov S2, P2
cmovg S0, P3
cmp P0, S2
cmovge S2, P0
cmovle P2, P0
cmovle P0, S2
cmp P0, P1
cmovle P0, P1
cmovl P1, S2
cmp P2, S0
cmovg P3, S0
