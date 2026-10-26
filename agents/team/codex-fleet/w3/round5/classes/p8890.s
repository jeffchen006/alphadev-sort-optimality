# n=5 model=out iset=I1 prefix14_class=8890
cmp P3, P2
mov S1, P3
cmovle S1, P2
cmovge P3, P2
cmp P0, P1
cmovge P2, P0
cmovg P0, P1
cmovg P1, P2
cmp P1, S1
mov S2, P0
cmovg S0, P1
cmovg P1, S1
cmovle S0, S1
cmp S2, P3
