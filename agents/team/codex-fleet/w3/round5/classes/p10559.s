# n=5 model=out iset=I1 prefix14_class=10559
mov S2, P1
mov S0, P3
cmp P0, S0
cmovg P3, P0
cmovle S0, P0
cmp P2, S2
cmovle S2, P2
cmovge P1, P2
cmp P3, P1
cmovle P0, P3
cmovle P3, P1
cmovle P1, P0
cmp S2, S0
cmovle P2, S0
