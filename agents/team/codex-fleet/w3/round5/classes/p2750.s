# n=5 model=out iset=I1 prefix14_class=2750
mov S1, P1
cmp S1, P3
cmovle S1, P3
cmovg P1, P3
mov P3, P2
cmp P3, P0
cmovle P2, P0
cmovge P3, P0
mov S0, P2
cmp S1, S0
cmovle P2, S1
cmovle S1, S0
cmp P3, P1
cmovle P0, P3
