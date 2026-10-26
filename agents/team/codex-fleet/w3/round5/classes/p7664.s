# n=5 model=out iset=I1 prefix14_class=7664
mov S0, P3
cmp P1, S0
cmovle P3, P1
mov S1, P0
cmovle P1, S0
cmp P2, S1
cmovge P0, P2
mov S0, P0
cmovg P2, S1
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
cmp S0, P1
