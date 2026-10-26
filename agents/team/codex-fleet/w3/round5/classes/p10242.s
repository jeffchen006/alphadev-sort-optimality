# n=5 model=out iset=I1 prefix14_class=10242
mov S1, P3
cmp P2, P1
cmovg S0, P2
cmovg P2, P1
cmovg P1, S0
cmp P0, S1
cmovge P3, P0
mov S2, P3
cmovge P0, S1
cmp S2, P1
cmovle S2, P1
cmovge P3, P1
mov P1, P2
cmp P0, P1
