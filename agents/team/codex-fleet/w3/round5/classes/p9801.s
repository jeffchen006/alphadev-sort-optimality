# n=5 model=out iset=I1 prefix14_class=9801
mov S1, P0
cmp P2, P3
cmovle S2, P3
cmovge S2, P2
cmovge P2, P3
cmp S1, P1
cmovg S1, P1
cmovl P0, P1
cmp S2, P0
cmovg P1, P0
cmovg P0, S2
cmovg S2, P1
mov P0, S1
cmp P2, P0
