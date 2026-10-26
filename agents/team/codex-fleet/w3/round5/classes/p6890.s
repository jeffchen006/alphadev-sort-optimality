# n=5 model=out iset=I1 prefix14_class=6890
mov S0, P2
cmp P1, S0
mov S2, P3
cmovle P2, P1
cmovl P1, S0
cmp P3, P0
cmovl P3, P0
mov S1, P3
cmovg S2, P0
cmp P1, P3
cmovl P3, P1
cmovge S1, P1
cmp P2, S2
cmovle S0, P2
