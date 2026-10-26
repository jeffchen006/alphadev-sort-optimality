# n=5 model=out iset=I1 prefix14_class=3403
mov S2, P3
mov S0, P2
cmp P0, S2
cmovle S2, P0
cmovg P3, P0
cmp P1, S0
cmovg P2, P1
cmovle S0, P1
mov P1, S0
cmp S2, P1
cmovge P1, S2
cmovg S2, S0
mov S0, P3
cmp P3, P2
