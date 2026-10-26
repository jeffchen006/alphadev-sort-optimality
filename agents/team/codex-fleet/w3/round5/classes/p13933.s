# n=5 model=out iset=I1 prefix14_class=13933
cmp P2, P3
cmovle S1, P2
mov S0, P1
cmovle P2, P3
cmovl P3, S1
cmp P0, P1
cmovg S0, P0
cmovg P0, P1
mov S2, P2
cmp P2, S0
cmovl P2, S0
cmovg S2, S0
cmp P0, P3
cmovge S0, P3
