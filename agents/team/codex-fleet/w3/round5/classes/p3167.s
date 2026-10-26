# n=5 model=out iset=I1 prefix14_class=3167
mov S2, P0
cmp P3, S2
cmovge P0, P3
cmovle S2, P3
cmp P2, P1
cmovg P3, P2
cmovg P2, P1
mov S1, S2
cmovg P1, P3
cmp S2, P2
cmovl S2, P2
cmovg S1, P2
cmp P1, P0
mov S1, P0
