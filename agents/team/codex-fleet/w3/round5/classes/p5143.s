# n=5 model=out iset=I1 prefix14_class=5143
cmp P3, P2
mov S0, P3
cmovle P3, P2
cmovle P2, S0
mov S2, P0
cmp P1, S2
cmovl P0, P1
cmovl P1, S2
cmp P2, P0
cmovge S0, P2
cmovge P2, P0
cmovg P0, S0
cmp P3, P1
cmovg S0, P1
