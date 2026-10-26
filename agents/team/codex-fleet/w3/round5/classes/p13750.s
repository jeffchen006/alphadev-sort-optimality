# n=5 model=out iset=I1 prefix14_class=13750
cmp P2, P1
mov S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P0, P3
mov S1, P3
cmovge S1, P0
cmovge P0, P3
cmp S2, S1
cmovge P1, S2
cmovg S2, S1
cmovg S1, P1
cmp P2, P0
cmovl P3, P2
