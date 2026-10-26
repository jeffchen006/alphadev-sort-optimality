# n=5 model=out iset=I1 prefix14_class=6618
cmp P1, P3
cmovle S1, P1
cmovg S1, P3
cmovg P3, P1
mov S2, P0
cmp P0, P2
cmovl S2, P2
cmovg P0, P2
cmovge P2, S2
cmp P3, P2
cmovg S2, P3
cmovg P3, P2
cmp S1, P0
cmovl S0, P0
