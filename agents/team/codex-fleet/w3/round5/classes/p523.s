# n=5 model=out iset=I1 prefix14_class=523
mov S0, P2
cmp P2, P3
cmovg P2, P3
cmovg P3, S0
mov S1, P1
cmp S1, P0
cmovg S1, P0
cmovge P0, P1
mov S0, P3
mov P1, P2
cmp S1, P2
cmovg P2, S1
cmovle P1, S1
cmovle S1, P2
