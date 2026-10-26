# n=5 model=out iset=I1 prefix14_class=9622
cmp P0, P3
mov S2, P2
cmovg S1, P0
cmovge P0, P3
cmovg P3, S1
cmp P2, P1
cmovle S2, P1
mov S0, P3
cmovge P2, P1
cmp S0, S2
cmovg P3, S2
cmovg S2, S0
cmp P2, P0
cmovl S2, P2
