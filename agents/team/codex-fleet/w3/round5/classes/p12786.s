# n=5 model=out iset=I1 prefix14_class=12786
mov S1, P0
cmp S1, P3
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
mov S2, P2
cmovle P2, P1
cmovge S2, P1
cmp P3, P2
mov S1, P0
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp S1, S2
