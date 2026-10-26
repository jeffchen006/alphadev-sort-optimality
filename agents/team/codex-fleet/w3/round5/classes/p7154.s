# n=5 model=out iset=I1 prefix14_class=7154
cmp P2, P3
mov S2, P0
cmovge S0, P2
cmovle S0, P3
cmovl P3, P2
cmp P1, S2
cmovle P0, P1
cmovl P1, S2
cmp P3, P0
cmovg S1, P3
mov P2, P1
cmovg P3, P0
cmovg P0, S1
cmp P1, S0
