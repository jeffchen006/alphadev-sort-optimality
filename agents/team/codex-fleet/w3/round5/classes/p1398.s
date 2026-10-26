# n=5 model=out iset=I1 prefix14_class=1398
cmp P1, P3
cmovle S2, P1
cmovl P1, P3
mov S0, P2
cmovg S2, P3
cmovge P3, P1
cmp P2, P0
cmovg S0, P0
cmovg P0, P2
cmp P3, P0
cmovl P3, P0
cmovl P0, P1
mov P3, S0
cmp P3, S2
