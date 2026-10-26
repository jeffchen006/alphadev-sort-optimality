# n=5 model=out iset=I1 prefix14_class=1234
cmp P0, P3
mov S0, P0
cmovl P0, P3
cmovl P3, S0
cmp P1, P2
mov S1, P1
cmovle S1, P2
cmovge P1, P2
cmp P0, S1
cmovg S2, P0
cmovge P0, S1
cmovg S1, S2
cmp P3, P1
mov S2, P3
