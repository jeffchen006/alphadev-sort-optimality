# n=5 model=out iset=I1 prefix14_class=3679
mov S1, P3
cmp P2, P3
cmovge S1, P2
cmovle P3, P2
mov S0, P0
cmp S0, P1
mov P2, P3
cmovle S0, P1
cmovle P1, P0
cmp P2, P1
cmovle P2, P1
cmovle P1, P3
cmp S0, S1
cmovge P3, S1
