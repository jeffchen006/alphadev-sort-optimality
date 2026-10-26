# n=5 model=out iset=I1 prefix14_class=2323
mov S1, P3
cmp P1, P2
mov S0, P1
cmovl P1, P2
cmovg S0, P2
cmp P3, P0
cmovle S1, P0
cmovge P3, P0
cmp P1, S1
mov S2, P1
cmovle S2, S1
cmovle S1, P1
cmp P3, S0
cmovle S2, S0
