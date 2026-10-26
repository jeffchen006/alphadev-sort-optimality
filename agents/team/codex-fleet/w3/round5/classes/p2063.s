# n=5 model=out iset=I1 prefix14_class=2063
cmp P3, P1
cmovle S0, P1
cmovge S0, P3
cmovl P1, P3
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
cmovg P0, S1
mov P3, P0
cmp P0, S0
cmovg P3, S0
mov S1, P3
cmovle P0, S0
mov P0, P2
