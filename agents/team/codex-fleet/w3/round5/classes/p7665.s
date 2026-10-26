# n=5 model=out iset=I1 prefix14_class=7665
mov S0, P3
cmp P1, S0
cmovle P3, P1
mov S1, P2
cmovle P1, S0
cmp P0, S1
cmovge P2, P0
mov S0, P2
cmovg P0, S1
cmp P0, P3
cmovle S1, P0
cmovle P0, P3
cmovle P3, S1
cmp S0, P1
