# n=5 model=out iset=I1 prefix14_class=3706
cmp P2, P3
cmovle S2, P2
cmovge S2, P3
cmovl P2, P3
mov P3, P1
mov S0, S2
cmp P3, P0
cmovl P1, P0
cmovle P0, P3
cmp P0, S2
cmovle S2, P0
mov S2, P2
cmovg S0, P0
mov S1, S0
