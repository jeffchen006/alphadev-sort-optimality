# n=5 model=out iset=I1 prefix14_class=338
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovg P1, P2
mov P2, P0
cmp P0, P3
cmovge P2, P3
cmovge P3, P0
cmovge P0, P2
cmp S1, P0
cmovl P0, S1
cmovle S1, P2
cmp P3, P1
cmovle S0, P1
