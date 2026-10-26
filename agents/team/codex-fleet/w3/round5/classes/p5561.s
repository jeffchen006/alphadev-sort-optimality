# n=5 model=out iset=I1 prefix14_class=5561
mov S2, P1
cmp P1, P2
cmovle S2, P2
cmovge P1, P2
cmp P0, P3
mov S1, P0
cmovl P0, P3
cmovl P3, S1
cmp P1, P3
cmovle S0, P3
cmovg S0, P1
cmovl P3, P1
mov S1, S2
mov P3, S0
