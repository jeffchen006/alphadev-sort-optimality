# n=5 model=out iset=I1 prefix14_class=3707
cmp P3, P1
cmovg S0, P1
cmovle S0, P3
cmovl P3, P1
mov P1, P0
cmp P0, P2
mov S2, S0
cmovl P1, P2
cmovl P2, P0
cmp P2, S2
cmovge S0, P2
cmovle S2, P2
mov S2, P1
mov P2, S0
