# n=5 model=out iset=I1 prefix14_class=9713
cmp P1, P3
mov S1, P3
cmovge P3, P1
cmovg P1, S1
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovle P0, P2
cmp S1, P3
cmovle S0, P3
mov P2, P1
cmovle P3, S1
cmovle S1, S0
cmp P2, P0
