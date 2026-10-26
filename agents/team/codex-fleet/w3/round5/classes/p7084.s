# n=5 model=out iset=I1 prefix14_class=7084
mov S0, P3
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovge P1, P2
mov P2, P0
cmp S1, P2
cmovle P0, S1
cmovge P2, S1
cmp P3, P1
cmovle S0, P1
