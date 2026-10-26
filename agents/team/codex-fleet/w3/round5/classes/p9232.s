# n=5 model=out iset=I1 prefix14_class=9232
cmp P2, P1
cmovg S2, P1
cmovge P1, P2
mov S1, P3
cmovg P2, S2
cmp P0, P3
cmovg P3, P0
mov S0, P2
cmovle S1, P0
cmp P2, S1
cmovl P2, S1
mov P0, P2
cmovle S1, S0
cmp P1, P3
