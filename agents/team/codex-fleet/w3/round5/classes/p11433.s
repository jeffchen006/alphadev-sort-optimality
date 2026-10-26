# n=5 model=out iset=I1 prefix14_class=11433
mov S0, P0
cmp P0, P3
cmovle S0, P3
cmovge P0, P3
cmp P2, P1
cmovge P3, P2
cmovge P2, P1
cmovg P1, P3
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
mov S2, S1
cmovl P0, P2
mov P0, P1
