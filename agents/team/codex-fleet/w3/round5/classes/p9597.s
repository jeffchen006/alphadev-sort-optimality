# n=5 model=out iset=I1 prefix14_class=9597
cmp P2, P3
cmovg S2, P2
cmovle S2, P3
cmovl P3, P2
cmp P0, P1
cmovge P2, P1
mov S1, S2
cmovge P1, P0
cmovge P0, P2
cmp S2, P1
cmovge S2, P1
cmovge P1, S1
cmp P0, P3
mov P1, P0
