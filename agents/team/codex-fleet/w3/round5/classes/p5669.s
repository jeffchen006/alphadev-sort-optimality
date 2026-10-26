# n=5 model=out iset=I1 prefix14_class=5669
cmp P3, P0
cmovg S0, P0
cmovle S0, P3
mov S2, P1
cmovg P0, P3
mov S1, S0
cmp P2, S2
cmovle S2, P2
cmovge P1, P2
cmp S2, S0
cmovle S1, S2
cmovle S2, S0
cmp P1, P0
mov S1, S2
